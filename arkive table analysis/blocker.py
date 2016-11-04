import magellan as mg
A = mg.read_csv('table_A.csv', key='ID')
B = mg.read_csv('table_B.csv', key='ID')

ab = attrEquivalenceBlocker()

C = ab.block_tables(A, B, 'name', 'animalName')





