# Copyright (c) 2016 Tobias Meissner
# Licensed under the MIT License (MIT)

output$libSize = renderTable({
  s <- dataInputExpr()
  s
})