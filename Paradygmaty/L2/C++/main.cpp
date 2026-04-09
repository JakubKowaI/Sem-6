#include <iostream>
#include "Ring.hpp"


int main(){
    Ring<4> a(8);
    Ring<4> b(8);
    std::cout<<a+b<<std::endl;
    std::cout<<a-b<<std::endl;
    std::cout<<a*b<<std::endl;
    std::cout<<a/b<<std::endl;
    std::cout<<a+b<<std::endl;
    return 0;
}