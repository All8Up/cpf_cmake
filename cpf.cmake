# ###############################################
# Setup all the configuration and versions as cache values
# so they can be overriden as needed.
set (CPF_TOOLCHAINS_VERSION
    "0.0.5"
    CACHE STRING "Toolchain release version."
)
set (CPF_HUNTER_GATE_FILE
    "https://raw.githubusercontent.com/hunter-packages/gate/c4e5b3e4d1c97fb46ae86af7f59baac95f7f1cf0/cmake/HunterGate.cmake"
    CACHE STRING "The hunter gate file to use."
)
set (CPF_HUNTER_CONFIG_FILE
    "https://raw.githubusercontent.com/All8Up/cpf_cmake/master/Config.cmake"
    CACHE STRING "Configuration file with hunter package information."
)
set (CPF_CMAKE_SETUP_FILE
    "https://raw.githubusercontent.com/All8Up/cpf_cmake/master/Setup.cmake"
    CACHE STRING "CPF cmake setup and configuration file."
)
set (HUNTER_CACHE_SERVERS
    "http://all8up.selfip.com:32771/artifactory/hunter"
    CACHE
    STRING
    "Default cache server"
)
if (NOT CPF_CONFIGURATION_TYPES)
    set (CPF_CONFIGURATION_TYPES Debug Release RelWithDebInfo CACHE STRING "")
endif ()

# ###############################################
# Dump details to console for debugging purposes.
message ("CPF_TOOLCHAINS_VERSION: ${CPF_TOOLCHAINS_VERSION}")
message ("CPF_HUNTER_GATE_FILE  : ${CPF_HUNTER_GATE_FILE}")
message ("CPF_HUNTER_CONFIG_FILE: ${CPF_HUNTER_CONFIG_FILE}")
message ("CPF_CMAKE_SETUP_FILE  : ${CPF_CMAKE_SETUP_FILE}")

# ###############################################
# Download the setup file and include it for further setup.
if (NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/_config/Setup.cmake")
    file (DOWNLOAD
        "${CPF_CMAKE_SETUP_FILE}"
        "${CMAKE_CURRENT_LIST_DIR}/_config/Setup.cmake"
    )
endif ()

include ("${CMAKE_CURRENT_LIST_DIR}/_config/Setup.cmake")
