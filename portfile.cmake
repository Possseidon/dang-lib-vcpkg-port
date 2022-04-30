vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Possseidon/dang-lib
  REF 139aa047d01e35edc0adee037849f61b59ffcbef
  SHA512 7b4fad9e7e534504fc10b281f43551f681be262bce380edf3579dabd8a14548057b92997188069c1f0c2e327d1cfee660265213ba583640f831fb1f6768cf13e
  HEAD_REF master
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    gl WITH_DANG_GL
    glfw WITH_DANG_GLFW
    lua WITH_DANG_LUA
    math WITH_DANG_MATH
    utils WITH_DANG_UTILS
)

if(
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
