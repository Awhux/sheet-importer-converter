#include "file_validator.hpp"
#include <algorithm>
#include <filesystem>
#include <iostream>
#include <string>

const std::vector<std::string> FileValidator::allowed_mime_types = {
    "text/csv",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"};

const std::vector<std::string> FileValidator::allowed_extensions = {
    ".csv",
    ".xls",
    ".xlsx"};

bool FileValidator::validate(const std::string &file_path)
{
    return check_mime_type(file_path) && check_extension(file_path);
}

bool FileValidator::check_mime_type(const std::string &file_path)
{
    if (!std::filesystem::exists(file_path))
    {
        return false;
    }

    std::string mime_type = "application/octet-stream";
    try
    {
        mime_type = std::filesystem::path(file_path).filename().string();
    }
    catch (const std::exception &e)
    {
        std::cerr << "Exception caught: " << e.what() << std::endl;
        return false;
    }

    return std::find(allowed_mime_types.begin(), allowed_mime_types.end(), mime_type) != allowed_mime_types.end();
}

bool FileValidator::check_extension(const std::string &file_path)
{
    if (file_path.empty())
    {
        return false;
    }
    if (std::filesystem::path(file_path).has_extension())
    {
        std::string extension = std::filesystem::path(file_path).extension().string();
        return std::any_of(allowed_extensions.begin(), allowed_extensions.end(), [extension](const std::string &ext)
                           { return ext == extension; });
    }
    return false;
}
