module HashFunctions

  # Polynomial Hash Functions

  ## For hashing integers
  #====================

  def integer_hash(a,b,p)
    ->(x){ (a*x+b)%p }
  end

  def generate_integer_hash(n)
    p = next_prime(n)
    integer_hash(rand(1...p),rand(p),p)
  end

  def reduced_hash(hash,m)
    ->(x){ hash.(x)%m }
  end

  def generate_reduced_hash(n,m)
    reduced_hash(generate_integer_hash(n),m)
  end

  ## For hashing strings or arrays of integers
  #==========================================
  #
  def polyhash_string(prime:p,x:)
    # Creates a hash function from the polynomial family with base parameter x and modulus p(prime)
    ->(string){
      result = 0
      x_to_i = 1
      string.chars.each.with_index do |char,i|
        result += (char.ord*x_to_i)%prime
        x_to_i *= x
        x_to_i = x_to_i%prime
      end
      result%prime
    }
  end

  def polyhash_integer(prime:,x:)
    polyhash_generator(prime:prime,x:x,converter:->(x){x})
  end

  def polyhash_generator(prime:,x:,converter:)
    # converter modifies the character type into into an integer
    ->(string){
      x_to_i = 1
      string.reduce(0) do |acc,char|
        acc += (converter.(char)*x_to_i)%prime
        x_to_i = (x_to_i*x)%prime
        acc
      end%prime
    }
  end

  def polyhash_slow(p,x)
    ->(string){
      string.map.with_index{|char,i| (char*x**i)%p }.reduce(&:+)%p
    }
  end


  def polyhash_recursive(pattern_size: ,text:, prime: , x: )
    exponentiation = modular_exponentiation(x,pattern_size,prime)
    ->(i,h){
        (h*x%prime - text[i+pattern_size].ord*exponentiation%prime + text[i].ord%prime)%prime
      }
  end

  # private

  def next_prime(n)
    loop do
      n += 1
      return n if Prime.prime? n
    end
  end

  def modular_exponentiation(base, exponent, modulus)
    return 0 if modulus == 1
    result = 1
    base = base%modulus
    while exponent > 0
      result = (result * base)%modulus  if (exponent%2 == 1)
      exponent = exponent >> 1
      base = (base * base)%modulus
    end
    result
  end

end
