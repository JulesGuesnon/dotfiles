local function file_exists(name)
  return vim.fn.filereadable(name) == 1
end

return {
  file_exists = file_exists,
}
