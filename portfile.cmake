vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Possseidon/dang-lib
  REF 0e5e78234a02ec6778fdd4c61a2b291042a3f0ce
  SHA512 3881ea2adf5d67d747749ad1e4935524360fc67f4bd1f29d521f9dbdeae69f9863151a8533378defacdbf067d265f2e4fd5bec72c69cf2725c361c90e89c56ee
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
