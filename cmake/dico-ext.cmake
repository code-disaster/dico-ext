cmake_path(GET CMAKE_CURRENT_LIST_DIR PARENT_PATH DICO_EXT_DIR)

#
# Defines shared library targets for steam_api and steamencryptedappticket if
# a local copy of the Steamworks SDK is found in `steamworks-sdk/`.
#
# The `DICO_EXT_HAS_STEAMWORKS` option can be used to disable those targets.
# You then can easily add some compile-time toggle with e.g.:
#
#   target_compile_definitions(${target} PRIVATE
#       HAS_STEAMWORKS=$<BOOL:${DICO_EXT_HAS_STEAMWORKS}>)
#
function (add_library_steamworks)
    if (EXISTS "${DICO_EXT_DIR}/steamworks-sdk/public/steam/steam_api.h")
        set(HAS_STEAMWORKS 1)
        #
        # steam_api
        #
        add_library(steam-api SHARED IMPORTED GLOBAL)
        target_include_directories(
            steam-api
            INTERFACE
            ${DICO_EXT_DIR}/steamworks-sdk/public/steam
        )
        if (WIN32)
            set_property(
                TARGET steam-api
                PROPERTY IMPORTED_IMPLIB
                ${DICO_EXT_DIR}/steamworks-sdk/redistributable_bin/win64/steam_api64.lib
            )
            set_property(
                TARGET steam-api
                PROPERTY IMPORTED_LOCATION
                ${DICO_EXT_DIR}/steamworks-sdk/redistributable_bin/win64/steam_api64.dll
            )
        elseif (UNIX AND NOT APPLE)
            set_property(
                TARGET steam-api
                PROPERTY IMPORTED_LOCATION
                ${DICO_EXT_DIR}/steamworks-sdk/redistributable_bin/linux64/libsteam_api.so
            )
        endif ()

        #
        # sdkencryptedappticket
        #
        add_library(steam-encryptedappticket SHARED IMPORTED GLOBAL)
        target_include_directories(
            steam-encryptedappticket
            INTERFACE
            ${DICO_EXT_DIR}/steamworks-sdk/public/steam
        )
        if (WIN32)
            set_property(
                TARGET steam-encryptedappticket
                PROPERTY IMPORTED_IMPLIB
                ${DICO_EXT_DIR}/steamworks-sdk/public/steam/lib/win64/sdkencryptedappticket64.lib
            )
            set_property(
                TARGET steam-encryptedappticket
                PROPERTY IMPORTED_LOCATION
                ${DICO_EXT_DIR}/steamworks-sdk/public/steam/lib/win64/sdkencryptedappticket64.dll
            )
        elseif (UNIX AND NOT APPLE)
            set_property(
                TARGET steam-encryptedappticket
                PROPERTY IMPORTED_LOCATION
                ${DICO_EXT_DIR}/steamworks-sdk/public/steam/lib/linux64/libsdkencryptedappticket.so
            )
        endif ()
    else ()
        set(HAS_STEAMWORKS 0)
    endif ()

    option(DICO_EXT_HAS_STEAMWORKS "Build with Steamworks support" ${HAS_STEAMWORKS})
endfunction ()

#
# Helper macro to link to steam_api. For EXECUTABLE targets, this also copies
# the shared library into the binary output folder.
#
macro (target_link_steamworks_libraries target)
    if (DICO_EXT_HAS_STEAMWORKS)
        target_link_libraries(
            ${target}
            PRIVATE
            steam-api
        )
        get_target_property(type ${target} TYPE)
        if (type STREQUAL EXECUTABLE)
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:steam-api> $<TARGET_FILE_DIR:${target}>
            )
        endif ()
    endif ()
endmacro ()

#
# Helper macro to link to steamencryptedappticket. For EXECUTABLE targets, this
# also copies the shared library into the binary output folder.
#
macro (target_link_steamworks_server_libraries target)
    if (DICO_EXT_HAS_STEAMWORKS)
        target_link_libraries(
            ${target}
            PRIVATE
            steam-encryptedappticket
        )
        get_target_property(type ${target} TYPE)
        if (type STREQUAL EXECUTABLE)
            add_custom_command(
                TARGET
                ${target}
                POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different
                $<TARGET_FILE:steam-encryptedappticket> $<TARGET_FILE_DIR:${target}>
            )
        endif ()
    endif ()
endmacro ()
