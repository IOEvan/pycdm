import glob
import os
import json
import logging
import subprocess


def get_shared_library_dependencies(so_file):
    try:
        # 使用subprocess调用ldd命令，并获取输出
        result = subprocess.run(['ldd', so_file],
                                capture_output=True,
                                text=True,
                                check=True)

        dependencies = {}

        # 解析ldd输出
        for line in result.stdout.splitlines():
            parts = line.split("=>")
            if len(parts) == 2:
                lib_name = parts[0].strip()
                lib_path = parts[1].strip().split()[0]
                dependencies[lib_name] = lib_path
            else:
                # 如果解析失败（通常是 vdso 这种特殊库），就直接保留原始行
                dependencies[line.strip()] = None

        return dependencies
    except subprocess.CalledProcessError as e:
        print(f"Error running ldd: {e}")
        return None


try:
    from .lib import _pycdm as _pycdm
    from .lib._pycdm import cdm, check
    from .lib._pycdm.cdm import CDMEngine, get_cdm_version, CdmCalVehInfo
    cdmlibrarypath = os.path.dirname(_pycdm.__file__)
except:
    #增加对开发环境的支持
    import _pycdm as _pycdm
    from _pycdm import cdm, check
    from _pycdm.cdm import CDMEngine, get_cdm_version, CdmCalVehInfo
    dependlibs = get_shared_library_dependencies(_pycdm.__file__)
    cdmlibrarypath = os.path.dirname(dependlibs['libcdm.so'])


def load_pncmessageso():
    import ctypes
    assert (os.path.exists(os.path.join(cdmlibrarypath, 'libcdm.so')))
    mazu_proto_path = os.path.join(cdmlibrarypath, 'libnio_messages_proto.so')
    pnc_proto_path = os.path.join(cdmlibrarypath, 'libpnc_common_proto.so')
    ctypes.CDLL(mazu_proto_path)
    ctypes.CDLL(pnc_proto_path)


load_pncmessageso()


def _get_topic_file_from_meta(metainfo, topic_name):
    if topic_name not in metainfo['topics']:
        logging.error('not find topic_name:%s in in meta', topic_name)
        return None
    filename = None
    filenames = metainfo['topics'][topic_name]
    if type(filenames) is dict:
        filename = filenames['file_name']
    elif type(filenames) is list:
        if len(filenames) == 0:
            logging.error('Empty file list in topic: %s', topic_name)
            return None
        elif len(filenames) >= 1:
            filename = filenames[0]
    elif type(filenames) is str:
        filename = filenames
    return filename

# co_replace_main_topics参数表示要用伴生topic的数据替换对应功能域topic的数据，默认为空列表
def get_topic_files(clip_dir:"str", topics:"list[str]", co_replace_main_topics:"list[str]"=[])->"dict[str, str]":
    if not os.path.exists(clip_dir):
        logging.error('Path is not exist!! ... %s', clip_dir)
        return {}
    metafile = os.path.join(clip_dir, 'meta.json')
    topic_files = {}
    loadmetasuccess = False
    if os.path.exists(metafile): # 路采数据分支
        try:
            with open(metafile, 'r') as f:
                metainfo = json.load(f)

            for topic in topics:
                filename = _get_topic_file_from_meta(metainfo,topic if topic.startswith('/') else '/' + topic)
                if filename is None:
                    continue
                logging.info('find file for topic: %s -> %s', topic, filename)
                fullpath = os.path.join(clip_dir, filename)
                assert os.path.exists(fullpath), fullpath
                topic_files[topic] = fullpath
            for co_topic in co_replace_main_topics:
                if not co_topic.startswith('coapp/'):
                    continue
                
                main_topic = co_topic[len("coapp/"):]
                if main_topic not in topics:
                    logging.error('%s Not found matched main topic', main_topic)
                    continue
                co_filename = _get_topic_file_from_meta(metainfo,co_topic if co_topic.startswith('/') else '/' + co_topic)
                if co_filename is None:
                    continue
                logging.info('find file for topic: %s -> %s', co_topic, co_filename)
                fullpath = os.path.join(clip_dir, co_filename)
                assert os.path.exists(fullpath), fullpath
                topic_files[main_topic] = fullpath
            loadmetasuccess = True
        except:
            logging.error('got exception while getting filepath from meta, try to use glob')
            pass
    if not loadmetasuccess:
        pbfiles = glob.glob(clip_dir + '/*.pb.dat')
        topic_files = {}
        isdlb = len(pbfiles) > 0
        if isdlb: # dlb录制数据分支
            for filename in pbfiles:
                basename = os.path.basename(filename)
                topic = '_'.join(basename.split('_')[1:-1]).replace('-', '/')
                if topic in topics:
                    topic_files[topic] = filename
                elif topic.startswith('coapp/') and topic in co_replace_main_topics:
                    stripped_topic = topic[len("coapp/"):]
                    if stripped_topic in topics:
                       topic_files[stripped_topic] = filename
        else: # 其他格式符合后缀为.dat 然后 topic name 中 / 字符被 - 替换的数据
            pbfiles = glob.glob(clip_dir + '/*.dat')
            for filename in pbfiles:
                basename_with_suffix = os.path.basename(filename)
                basename = os.path.splitext(basename_with_suffix)[0]
                matchtopics = [
                    topic for topic in topics
                    if basename == topic.replace('/', '-')
                ]
                if matchtopics:
                    topic_files[matchtopics[0]] = filename
    for topic in topics:
        if topic not in topic_files:
            logging.warning('Warning not find file for %s', topic)
        else:
            logging.info('%s matched %s', topic, topic_files[topic])

    return topic_files
