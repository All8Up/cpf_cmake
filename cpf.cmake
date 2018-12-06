# ###############################################
set (TOOLCHAINS_VERSION 0.0.5)
message ("TOOLCHAINS_VERSION: ${CPF_TOOLCHAINS_VERSION}")

# ###############################################
# Setup the cache server to download prebuilt binaries.
set(HUNTER_CACHE_SERVERS
    "http://all8up.selfip.com:32771/artifactory/hunter"
    CACHE
    STRING
    "Default cache server"
)

# ###############################################
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
# If the config version is not set by the caller, download it.
file (DOWNLOAD
    "https://github.com/All8Up/cpf_config/releases/download/v0.0.0/Version.txt"
    "${CMAKE_CURRENT_LIST_DIR}/_config/Version.txt"
)

# ###############################################
# Get the configuration project.
cpf_download_release (cpf_config ${CPF_CONFIG_VERSION})
set (CPF_CONFIG_DIR "${CMAKE_CURRENT_LIST_DIR}/_config/cpf_config")

# ###############################################
# Get the toolchains project.
cpf_download_release (cpf_toolchains ${CPF_TOOLCHAINS_VERSION})

# ###############################################
if (NOT CPF_CONFIG)
    set (CPF_CONFIG "${CPF_CONFIG_DIR}/Config.cmake")
endif ()
include ("${CPF_CONFIG_DIR}/Setup.cmake")
include (hunter_protected_sources)
