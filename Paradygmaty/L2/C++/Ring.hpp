#pragma once

template <int n>
class Ring
{
private:
    int val;

    static int NWD(int a, int b){
        while (b != 0) {
            int t = b;
            b = a % b;
            a = t;
        }
        return a;
    }

    static int euklides(const int a, const int b, int *x, int *y){
        if (b == 0) {
            *x = 1;
            *y = 0;
            return a;
        }
        int x1 = 0;
        int y1 = 0;
        int d = euklides(b, a % b, &x1, &y1);
        *x = y1;
        *y = x1 - (a / b) * y1;
        return d;
    }

    Ring inv(const Ring& b) const {
        try
        {
            if((b.val==0)||(NWD(b.val,n)!=1)){
                throw std::runtime_error("Brak odwrotności w pierscieniu");
            }else{
                int x =1,y=1;
                euklides(b.val,n,&x,&y);
                x = ((x % n) + n) % n;
                return Ring(x);
            }
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }
    
public:
    // Ring(int x){
    //     val = ((x % n) + n) % n;
    // }
    Ring(int x) : val(((x % n) + n) % n) {}

    //operator int() const { return val; }

    bool operator ==(const Ring& b) const {
        try
        {
            return val==b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    bool operator !=(const Ring& b) const {
        try
        {
            return val!=b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    bool operator <=(const Ring& b) const {
        try
        {
            return val<=b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    bool operator >=(const Ring& b) const {
        try
        {
            return val>=b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    bool operator >(const Ring& b) const {
        try
        {
            return val>b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    bool operator <(const Ring& b) const {
        try
        {
            return val<b.val;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring<n> operator +(const Ring& b) const {
        try
        {
            std::cout<<"N: "<<n<<std::endl;
            return Ring<n>(val+b.val);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring operator -(const Ring& b) const {
        try
        {
            return Ring(val-b.val);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring operator *(const Ring& b) const {
        try
        {
            return Ring(val*b.val);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring operator /(const Ring& b) const {
        try
        {
            return Ring(val*inv(b).val);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring& operator =(const Ring& b){
        try
        {
            val=b.val;
            return *this;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring& operator +=(const Ring& b){
        try
        {
            val = ((val + b.val) % n + n) % n;
            return *this;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring& operator -=(const Ring& b){
        try
        {
            val = ((val - b.val) % n + n) % n;
            return *this;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring& operator *=(const Ring& b){
        try
        {
            val = ((val * b.val) % n + n) % n;
            return *this;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    Ring& operator /=(const Ring& b){
        try
        {
            val = ((val * inv(b).val) % n + n) % n;
            return *this;
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            throw;
        }
    }

    friend std::ostream& operator<<(std::ostream& os, const Ring& r) {
        return os << r.val;
    }

    ~Ring() = default;
};