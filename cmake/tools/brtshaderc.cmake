# bgfx.cmake - bgfx building in cmake
# Written in 2017 by Joshua Brookover <joshua.al.brookover@gmail.com>

# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.

# You should have received a copy of the CC0 Public Domain Dedication along with
# this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

include( CMakeParseArguments )

include( cmake/3rdparty/fcpp.cmake )
include( cmake/3rdparty/glsl-optimizer.cmake )
include( cmake/3rdparty/glslang.cmake )
include( cmake/3rdparty/spirv-cross.cmake )
include( cmake/3rdparty/spirv-tools.cmake )
include( cmake/3rdparty/webgpu.cmake )

include_directories(${BGFX_DIR}/include/)

add_library( brtshaderc STATIC
    #src/
    ${BGFX_DIR}/src/shader_dx9bc.cpp
    ${BGFX_DIR}/src/shader_dxbc.cpp
    ${BGFX_DIR}/src/shader.cpp
    #tools/shaderc
    ${BGFX_DIR}/tools/shaderc/shaderc.cpp
    ${BGFX_DIR}/tools/shaderc/shaderc.h
    ${BGFX_DIR}/tools/shaderc/shaderc_glsl.cpp
    ${BGFX_DIR}/tools/shaderc/shaderc_hlsl.cpp
    ${BGFX_DIR}/tools/shaderc/shaderc_pssl.cpp
    ${BGFX_DIR}/tools/shaderc/shaderc_metal.cpp
    #tools/brtshaderc
    ${BGFX_DIR}/tools/brtshaderc/brtshaderc.cpp
    ${BGFX_DIR}/tools/brtshaderc/brtshaderc.h
    ${BGFX_DIR}/tools/brtshaderc/brtshaderc_spirv.cpp )

target_compile_definitions( brtshaderc PRIVATE "-D_CRT_SECURE_NO_WARNINGS" )
set_target_properties( brtshaderc PROPERTIES FOLDER "bgfx/tools" )
target_link_libraries(brtshaderc PRIVATE bx bimg bgfx-vertexlayout bgfx-shader-spirv fcpp glsl-optimizer glslang spirv-cross spirv-tools webgpu)

if( BGFX_CUSTOM_TARGETS )
    add_dependencies( tools brtshaderc )
endif()

if (ANDROID)
    target_link_libraries(brtshaderc PRIVATE log)
elseif (IOS)
    set_target_properties(brtshaderc PROPERTIES MACOSX_BUNDLE ON
        MACOSX_BUNDLE_GUI_IDENTIFIER brtshaderc)
endif()
