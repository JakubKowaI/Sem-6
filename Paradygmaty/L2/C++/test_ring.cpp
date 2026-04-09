#include <iostream>
#include <stdexcept>
#include "Ring.hpp"

int main(){
    int failures = 0;

    // Test arithmetic in mod 7 (prime modulus -> every nonzero has inverse)
    // try{
    //     Ring<7> a(3), b(5); // 3,5
    //     Ring<7> sum = a + b; // 3+5=8 mod7 =1
    //     if((int)sum != 1){ std::cerr<<"FAIL add: expected 1 got "<<(int)sum<<"\n"; ++failures; }

    //     Ring<7> sub = a - b; // 3-5 = -2 mod7 =5
    //     if((int)sub != 5){ std::cerr<<"FAIL sub: expected 5 got "<<(int)sub<<"\n"; ++failures; }

    //     Ring<7> mul = a * b; // 3*5=15 mod7 =1
    //     if((int)mul != 1){ std::cerr<<"FAIL mul: expected 1 got "<<(int)mul<<"\n"; ++failures; }

    //     // division: inv(5) mod7 = 3 because 5*3=15=1 mod7; 3/5=3*3=9 mod7=2
    //     Ring<7> div = a / b;
    //     if((int)div != 2){ std::cerr<<"FAIL div: expected 2 got "<<(int)div<<"\n"; ++failures; }

    //     // compound assignment
    //     Ring<7> c(2);
    //     c += Ring<7>(6); // 2+6=8 mod7=1
    //     if((int)c != 1){ std::cerr<<"FAIL += got "<<(int)c<<"\n"; ++failures; }

    //     c = Ring<7>(3);
    //     c -= Ring<7>(5); // 3-5=-2 mod7=5
    //     if((int)c != 5){ std::cerr<<"FAIL -= got "<<(int)c<<"\n"; ++failures; }

    //     c = Ring<7>(4);
    //     c *= Ring<7>(2); // 8 mod7 =1
    //     if((int)c != 1){ std::cerr<<"FAIL *= got "<<(int)c<<"\n"; ++failures; }

    // } catch(const std::exception& e){ std::cerr<<"Unexpected exception in invertible tests: "<<e.what()<<"\n"; ++failures; }

    // // Test non-invertible division (mod 4, element 2 has no inverse)
    // try{
    //     Ring<4> x(2), y(2);
    //     bool threw = false;
    //     try{
    //         Ring<4> r = x / y;
    //         (void)r;
    //     }catch(const std::runtime_error&){ threw = true; }
    //     catch(...){ std::cerr<<"FAIL unexpected exception type for non-invertible case\n"; ++failures; }
    //     if(!threw){ std::cerr<<"FAIL expected runtime_error for non-invertible division\n"; ++failures; }
    // }catch(...){ std::cerr<<"Unexpected failure in non-invertible test\n"; ++failures; }

    // // Test zero division (b == 0)
    // try{
    //     Ring<5> p(3), z(0);
    //     bool threw = false;
    //     try{ auto r = p / z; (void)r; }
    //     catch(const std::runtime_error&){ threw = true; }
    //     catch(...){ std::cerr<<"FAIL unexpected exception type for zero division\n"; ++failures; }
    //     if(!threw){ std::cerr<<"FAIL expected runtime_error for division by zero\n"; ++failures; }
    // }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    // if(failures==0){ std::cout<<"ALL TESTS PASSED\n"; }
    // else{ std::cout<<failures<<" TEST(S) FAILED\n"; }

    try{
        std::cout<<(Ring<13>(12)+Ring<15>(12))<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<Ring<13>(0)-Ring<13>(1)<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<Ring<13>(2)*Ring<13>(-2)<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<Ring<13>(13)/Ring<13>(3)<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<Ring<13>(13)/Ring<13>(0)<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<(Ring<13>(7)>Ring<13>(-1))<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    try{
        std::cout<<(Ring<13>(-2)==Ring<13>(11))<<std::endl;
    }catch(...){ std::cerr<<"Unexpected failure in zero-division test\n"; ++failures; }

    return failures;
}
