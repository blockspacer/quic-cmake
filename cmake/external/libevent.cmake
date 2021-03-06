include(ExternalProject)
include(utils)

add_custom_target(libevent)

set(LIBEVENT_PREFIX ${CMAKE_BINARY_DIR}/deps/libevent)
set(LIBEVENT_INSTALL ${LIBEVENT_PREFIX}/install)
set(LIBEVENT_SOURCE ${LIBEVENT_PREFIX}/src/libevent)
set(LIBEVENT_BINARY ${LIBEVENT_SOURCE}-build)

set(LIBEVENT_INCLUDE_DIRS
  ${LIBEVENT_INSTALL}/include
)

set(LIBEVENT_STATIC_LIBRARIES
  ${LIBEVENT_INSTALL}/lib/libevent.a
  ${LIBEVENT_INSTALL}/lib/libevent_core.a
  ${LIBEVENT_INSTALL}/lib/libevent_extra.a
)

CHECK_ALL_EXISTS(LIBEVENT_FOUND ${LIBEVENT_INCLUDE_DIRS} ${LIBEVENT_STATIC_LIBRARIES})

if(NOT LIBEVENT_FOUND)
  set(LIBEVENT_URL https://github.com/libevent/libevent)
  set(LIBEVENT_TAG e7ff4ef2b4fc950a765008c18e74281cdb5e7668)

  ExternalProject_Add(libevent_external
    PREFIX "${LIBEVENT_PREFIX}"
    GIT_REPOSITORY "${LIBEVENT_URL}"
    GIT_TAG "${LIBEVENT_TAG}"
    DOWNLOAD_DIR "${LIBEVENT_PREFIX}"
    SOURCE_DIR "${LIBEVENT_SOURCE}"
    BINARY_DIR "${LIBEVENT_BINARY}"
    # BUILD_IN_SOURCE 1
    CMAKE_CACHE_ARGS
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DCMAKE_INSTALL_PREFIX:PATH=${LIBEVENT_INSTALL}
        -DOPENSSL_ROOT_DIR:PATH=${BORINGSSL_BINARY}
        -DOPENSSL_USE_STATIC_LIBS:BOOL=ON
        -DEVENT__DISABLE_TESTS:BOOL=ON
        -DEVENT__DISABLE_REGRESS:BOOL=ON
        -DEVENT__DISABLE_SAMPLES:BOOL=ON
        -DEVENT__DISABLE_BENCHMARK:BOOL=ON
        -DEVENT__BUILD_SHARED_LIBRARIES:BOOL=OFF
    DEPENDS
      boringssl
    BUILD_BYPRODUCTS ${LIBEVENT_STATIC_LIBRARIES}
  )

  add_dependencies(libevent libevent_external)
endif()
