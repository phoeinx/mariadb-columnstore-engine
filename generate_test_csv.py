import argparse
from faker import Faker

# Parse arguments from command line
parser = argparse.ArgumentParser(description='Generate CSV test data with specified column names and types using Pythons faker library.')
parser.add_argument('--column_names', type=str, help='Column names seperated by comma. Example: id,name,age')
parser.add_argument('--column_types', type=str, help='Column types seperated by comma. Supported: int,char,float,datetime,str. Example: int,char,float')
parser.add_argument('--output', type=str, default='test_data.csv', help='Output file name')
parser.add_argument('--size', type=int, default=100, help='Approx. size of output file in MB')
args = parser.parse_args()

if len(args.column_names.split(',')) != len(args.column_types.split(',')):
    print("ERROR: column_names and column_types must have the same number of elements")
    exit(1)

# Add support for new data types here (and update the help text for parser argument column_types.)
def generate_data_for_type(col_type):
    match col_type:
        case 'float':
            return str(fake.pyfloat())
        case 'datetime':
            return str(fake.date_time_between(start_date='-1y', end_date='now'))
        case 'int':
            return str(fake.random_int())
        case 'char':
            return fake.random_letter()
        case 'str':
            return fake.text()
        case _:
            print("ERROR: column type {} not supported".format(col_type))
            exit(1)

fake = Faker()
with open(args.output, 'w') as f:
    f.write(args.column_names + '\n')
    while f.tell() < args.size * 1024 * 1024:
        row = []
        for col_type in args.column_types.split(','):
            row.append(generate_data_for_type(col_type))
        f.write(','.join(row) + '\n')
        print("Progress: {}%".format(round(f.tell()/(args.size * 1024 * 1024)*100,2)), end="\r")



