# ###############################################
file (DOWNLOAD
    "${CPF_HUNTER_GATE_FILE}"
    "${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake"
)
file (DOWNLOAD
    "${CPF_HUNTER_CONFIG_FILE}"
    "${CMAKE_CURRENT_LIST_DIR}/Config.cmake"
)

# ###############################################
# Setup the cache server to download prebuilt binaries.
set(HUNTER_CACHE_SERVERS
    "http://all8up.selfip.com:32771/artifactory/hunter"
    CACHE
    STRING
    "Default cache server"
)

# ###############################################
set_property (GLOBAL PROPERTY USE_FOLDERS ON)
set (CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo CACHE STRING "")
set (HUNTER_CONFIGURATION_TYPES Debug Release RelWithDebInfo CACHE STRING "" FORCE)
include (hunter_protected_sources)

# ###############################################
if (NOT CPF_CONFIG)
    set (CPF_CONFIG "${CMAKE_CURRENT_LIST_DIR}/Config.cmake")
endif ()

# ###############################################
# Helper to download a release zip and decompress it.
macro (cpf_download_release project version)
    if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/_config/${project}-v${version}.zip")
        message ("${project} already downloaded.")
    else ()
        message ("Downloading ${project}.")
        file (DOWNLOAD
            "https://github.com/All8Up/${project}/archive/v${version}.zip"
            "${CMAKE_CURRENT_LIST_DIR}/_config/${project}-v${version}.zip"
        )
        message ("Unzipping ${project}.")
        execute_process (
            COMMAND ${CMAKE_COMMAND} -E tar "x" "${CMAKE_CURRENT_LIST_DIR}/_config/${project}-v${version}.zip" --format=zip
            WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/_config"
        )
        file (REMOVE_RECURSE "${CMAKE_CURRENT_LIST_DIR}/_config/${project}")
        file (RENAME
            "${CMAKE_CURRENT_LIST_DIR}/_config/${project}-${version}"
            "${CMAKE_CURRENT_LIST_DIR}/_config/${project}"
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
# Add a custom property to associate IDL files with targets.
define_property (TARGET
    PROPERTY CPF_IDL_DIR
    BRIEF_DOCS "The directory containing IDL files for the target."
    FULL_DOCS "The directory containing IDL files for the target."
)

# ###############################################
set (HUNTER_KEEP_PACKAGE_SOURCES ON)
include ("${CMAKE_CURRENT_LIST_DIR}/HunterGate.cmake")
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.53.tar.gz"
    SHA1 "5d9feddb1ebeca27e32634954fe4de37cf36f97d"
    FILEPATH "${CPF_CONFIG}"
)
