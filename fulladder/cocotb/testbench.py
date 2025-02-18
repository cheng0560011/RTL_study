import cocotb
from cocotb.triggers import Timer
import google.generativeai as genai
import csv
import os

GOOGLE_API_KEY='AIzaSyBTAOfFp5I-CseKr3iPucy9kKxdGw0msQc'
genai.configure(api_key = GOOGLE_API_KEY)

prompt = 'Complete the truth table with all possible input_a, input_b, carry_in for a full adder. Output should be csv format with on other information, no header or ending'

@cocotb.test()
async def simple_test(dut):

	"""Generate truth table by Google gemini-1.5-flash and verify dut with it"""

	os.environ["DEBUG_MODE"] = "1"

	model = genai.GenerativeModel('gemini-1.5-flash')
	response = model.generate_content(prompt)
	debug_print(f'Raw response text:{response.text}')

	with open('truth_table.csv', 'w', encoding='utf-8') as file:
		file.write(response.text.strip())  # Remove unnecessary whitespace
	debug_print('CSV successfully saved as output.csv')

	with open('truth_table.csv') as csvfile:
		csvreader = csv.reader(csvfile)
		for row in csvreader:
			row_int = [int(value) for value in row]
			debug_print(f'ROW: {row[0]}, {row[1]}, {row[2]}, {row[3]}, {row[4]}')
			[dut.a.value, dut.b.value, dut.cin.value] = [row_int[0], row_int[1], row_int[2]]
			await Timer(1, units='ns')
			assert dut.sum.value == row_int[3], f'Test failed: expected sum={row[3]}, got sum = {dut.sum.value}'
			assert dut.cout.value == row_int[4], f'Test failed: expected cout={row[4]}, got sum = {dut.cout.value}'

def debug_print(msg):
	if os.getenv("DEBUG_MODE") == "1":
		print(msg)
