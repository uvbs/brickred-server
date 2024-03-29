#include <iostream>
#include <string>
#include <vector>
#include <ext/hash_map>

#include <brickred/string_util.h>

using namespace brickred;

int main(void)
{
    char str[] = ";1;2;3;";
    std::vector<std::string> result;

    string_util::split(str, ";", &result);

    for (size_t i = 0; i < result.size(); ++i) {
        std::cout << result[i] << std::endl;
    }

    __gnu_cxx::hash_map<std::string,
                        std::string,
                        string_util::Hash> m;
    m["111"] = "222";
    std::cout << m["111"] << std::endl;

    return 0;
}
