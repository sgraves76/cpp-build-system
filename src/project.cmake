# NOTE: For Windows Inno Setup support, create the following '.iss' file in:
#  "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.iss.in"

add_project_library(lib${PROJECT_NAME} "" "" "${PROJECT_ADDITIONAL_SOURCES}")

add_project_executable(${PROJECT_NAME} lib${PROJECT_NAME} lib${PROJECT_NAME})
if (PROJECT_IS_DARWIN AND EXISTS "${CMAKE_SOURCE_DIR}/${PROJECT_NAME}/Info.plist")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}/Info.plist
  )
endif()

add_project_test_executable(${PROJECT_NAME}_test lib${PROJECT_NAME} lib${PROJECT_NAME})
