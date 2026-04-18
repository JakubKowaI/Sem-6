#include "RSA.hpp"
#include "DHSetup.hpp"
#include "User.hpp"

#include <iostream>

int main(){
    RSA<Ring<10007*10009>> rsa(10007,10009);

    Ring<10007*10009> m(21152115);
    Ring<10007*10009> s = rsa.encrypt(m);
    Ring<10007*10009> decrypted = rsa.decrypt(s);

    std::cout<<decrypted<<std::endl;

    DHSetup<Ring<10007>> dh(10007);
    User<Ring<10007>> alice(dh);
    User<Ring<10007>> bob(dh);
 
    Ring<10007> a_pub = alice.getPublicKey();
    Ring<10007> b_pub = bob.getPublicKey();
 
    alice.setKey(b_pub);
    bob.setKey(a_pub);
 
    Ring<10007> ka = alice.getSharedKey();
    Ring<10007> kb = bob.getSharedKey();
    Ring<10007> mm(2115);
    Ring<10007> c = alice.encrypt(mm);
    Ring<10007> d = bob.decrypt(c);

    std::cout << "ka=" << ka << " kb=" << kb << " m=" << mm << " d=" << d << "\n";
    return (ka == kb && mm == d) ? 0 : 1;

    return 0;
}