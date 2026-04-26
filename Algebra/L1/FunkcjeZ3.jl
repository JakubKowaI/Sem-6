function minimalny()
    
end

function xLTy(x::Vector{Int}, y::Vector{Int})
    for i in eachindex(x)
        if x[i] > y[i]
            return false
        end
    end
    return true
end

function xLEy(x::Vector{Int}, y::Vector{Int})
    return xLTy(x, y) && x != y
end

function elMin(A::Vector{Vector{Int}})
    result = Vector{Vector{Int}}()

    for x in A
        is_min = true
        for y in A
            if y != x && xLEy(y, x)
                is_min = false
                break
            end
        end
        if is_min
            push!(result, x)
        end
    end

    return result
end

function generate_A(a::Int, b::Int, r2::Int)
    A = Vector{Vector{Int}}()

    # sensowny zakres przeszukiwania
    for x in max(0, a-5):a+5
        for y in max(0, b-5):b+5
            if (x - a)^2 + (y - b)^2 <= r2
                push!(A, [x, y])
            end
        end
    end

    return A
end

function generate_B(c::Int, d::Int, e::Int, f::Int, r2::Int)
    B = Vector{Vector{Int}}()

    for x1 in max(0, c-10):c+10
        for x2 in max(0, d-10):d+10
            for x3 in max(0, e-10):e+10
                for x4 in max(0, f-10):f+10
                    if (x1-c)^2 + (x2-d)^2 + (x3-e)^2 + (x4-f)^2 > r2
                        push!(B, [x1, x2, x3, x4])
                    end
                end
            end
        end
    end

    return B
end