#include <iostream>

int main() {
#if defined(TEST_WINDOWS)
  std::cout << "windows" << std::endl;
#elif defined(TEST_LINUX)
  std::cout << "linux" << std::endl;
#elif defined(TEST_MACOS)
  std::cout << "macos" << std::endl;
#else
  std::cout << "default" << std::endl;
#endif

  return 0;
}
