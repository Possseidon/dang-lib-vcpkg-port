vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Possseidon/dang-lib
  REF f2048117f12262d85545b86249dd7dd55e162672
  SHA512 d35eb03dcfdb9b076a9665646e807c8eb1b21a6e957d8dc9ede9c8e004d5b5b14047f3f602b3fe6fb0678704b8269d2f0264698da47a70e163017ba91a71a7ea
  HEAD_REF master
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    box2d WITH_DANG_BOX2D
    gl WITH_DANG_GL
    glfw WITH_DANG_GLFW
    lua WITH_DANG_LUA
    math WITH_DANG_MATH
    utils WITH_DANG_UTILS
)

if(
  NOT WITH_DANG_BOX2D AND
  NOT WITH_DANG_GL AND
  NOT WITH_DANG_GLFW AND
  NOT WITH_DANG_LUA AND
  NOT WITH_DANG_MATH AND
  NOT WITH_DANG_UTILS
)
  message(FATAL_ERROR "dang-lib must have at least one feature selected.")
endif()

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DBUILD_TESTING=OFF
    -DWITH_DANG_DOC=OFF
    -DWITH_DANG_EXAMPLE=OFF
    ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup()

if (WITH_DANG_GL OR WITH_DANG_GLFW)
  # Contains static libraries.
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
else()
  # Header only, no libraries.
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
endif()

# TODO: Use a proper license instead of just README.md.
file(
  INSTALL "${SOURCE_PATH}/README.md"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright
)
