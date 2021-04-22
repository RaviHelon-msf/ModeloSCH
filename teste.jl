using CSV
using DataFrames

a = CSV.File("""data.lvm""",header=0, type=Float64)
b = [Array(a.Column1), Array(a.Column4), Array(a.Column5)]
