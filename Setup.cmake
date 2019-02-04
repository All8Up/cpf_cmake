# ###############################################
set (CMAKE_CONFIGURATION_TYPES ${CPF_CONFIGURATION_TYPES} CACHE STRING "" FORCE)
set (HUNTER_CONFIGURATION_TYPES ${CPF_CONFIGURATION_TYPES} CACHE STRING "" FORCE)

# ###############################################
if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake"
    OR NOT CPF_CONFIGURATION_COMPLETE)
    file (DOWNLOAD
        "${CPF_HUNTER_GATE_FILE}"
        "${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake"
    )
    message ("Downloaded hunter gate.")
endif ()
if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/Config.cmake"
    OR NOT CPF_CONFIGURATION_COMPLETE)
    file (DOWNLOAD
        "${CPF_HUNTER_CONFIG_FILE}"
        "${CMAKE_CURRENT_LIST_DIR}/Config.cmake"
    )
    message ("Downloaded config.")
endif ()

# ###############################################
set_property (GLOBAL PROPERTY USE_FOLDERS ON)

# ###############################################
if (NOT CPF_CONFIG)
    set (CPF_CONFIG "${CMAKE_CURRENT_LIST_DIR}/Config.cmake")
endif ()

# ###############################################
# Helper to download a release zip and decompress it.
macro (cpf_download_release project version)
    if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/${project}-v${version}.zip")
        message ("${project} already downloaded.")
    else ()
        message ("Downloading ${project}.")
        file (DOWNLOAD
            "https://github.com/All8Up/${project}/archive/v${version}.zip"
            "${CMAKE_CURRENT_LIST_DIR}/${project}-v${version}.zip"
        )
        message ("Unzipping ${project}.")
        execute_process (
            COMMAND ${CMAKE_COMMAND} -E tar "x" "${CMAKE_CURRENT_LIST_DIR}/${project}-v${version}.zip" --format=zip
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        )
        file (REMOVE_RECURSE "${CMAKE_CURRENT_LIST_DIR}/${project}")
        file (RENAME
            "${CMAKE_CURRENT_LIST_DIR}/${project}-${version}"
            "${CMAKE_CURRENT_LIST_DIR}/${project}"
        )
    endif ()
endmacro ()

# ###############################################
# Get the toolchains project.
cpf_download_release (cpf_toolchains ${CPF_TOOLCHAINS_VERSION})

# ###############################################
option (CPF_BUILD_SHARED "Build libraries as shared." OFF)
if (CPF_BUILD_SHARED)
    set (BUILD_SHARED_LIBS ON CACHE STRING "Build shared libraries." FORCE)
endif ()

# ###############################################
set (CPF_CONFIGURATION_COMPLETE ON CACHE STRING "CPF Configured." FORCE)

# ###############################################
set (HUNTER_KEEP_PACKAGE_SOURCES ON)
include ("${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake")
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.94.tar.gz"
    SHA1 "3f4c104df81f1c4a627f4b0ea9f3306de1b0b54b"
    FILEPATH "${CPF_CONFIG}"
)
include (hunter_protected_sources)
