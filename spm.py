def verify_spm_algorithm():
    # Parameters
    N = 8
    Q = 4096

    # Input polynomials (same as testbench)
  #  a= [8, 7, 6, 5, 4, 3, 2, 1]
   # b= [8, 7, 6, 5, 4, 3, 2, 1]
    a=[1,2,3,4,5,6,7,8]
    b=[1,2,3,4,5,6,7,8]

    #a=[1,2,0,0,1,0,0,4]
    #b=[1,2,0,0,3,0,0,1]


    # Your simulation output (from log)
    #simulated_c = [187, 211, 243, 32, 116, 132, 156, 188]

    # Initialize output
    C = [0] * N

    # Algorithm implementation
    for i in range(0, N//2 - 3, 4):  # i += 4
        for j in range(N):
            # Transform matrix A
            if j < N//2:
                A0 = a[j]
                A1 = a[(j + N//2) % N]
            else:
                A0 = (-a[j]) #% Q  # Key difference!
                A1 = a[(j + N//2) % N]

            # Transform matrix B
            B0 = b[(i - j) % N]
            B1 = b[(i - j + 1) % N]
            B2 = b[(i - j + 2) % N]
            B3 = b[(i - j + 3) % N]

            # Compute temp products
            temp = [
                (A0 * B0) % Q,
                (A0 * B1) % Q,
                (A0 * B2) % Q,
                (A0 * B3) % Q,
                (A1 * B0) % Q,
                (A1 * B1) % Q,
                (A1 * B2) % Q,
                (A1 * B3) % Q
            ]

            # Accumulate results
            C[i] = (C[i] + temp[0]) % Q
            C[i+1] = (C[i+1] + temp[1]) % Q
            C[i+2] = (C[i+2] + temp[2]) % Q
            C[i+3] = (C[i+3] + temp[3]) % Q
            C[(i + N//2) % N] = (C[(i + N//2) % N] + temp[4]) % Q
            C[(i + N//2 + 1) % N] = (C[(i + N//2 + 1) % N] + temp[5]) % Q
            C[(i + N//2 + 2) % N] = (C[(i + N//2 + 2) % N] + temp[6]) % Q
            C[(i + N//2 + 3) % N] = (C[(i + N//2 + 3) % N] + temp[7]) % Q

    print("=== Algorithm Verification ===")
    print("Computed Result (Python Implementation):")
    for k in range(N):
        print(f"C[{k}] = {C[k]}")




verify_spm_algorithm()
