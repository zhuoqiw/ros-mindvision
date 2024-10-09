if(NOT TARGET mindvision::mindvision)
  add_library(mindvision::mindvision SHARED IMPORTED)
  set_target_properties(mindvision::mindvision PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/lib/libMVSDK.so"
    IMPORTED_NO_SONAME TRUE
  )
endif()