#pragma once
#ifndef FILE_VALIDATOR_HPP
#define FILE_VALIDATOR_HPP

#include <string>
#include <vector>

class FileValidator
{
public:
    static bool validate(const std::string &file_path);

private:
    static bool check_mime_type(const std::string &file_path);
    static bool check_extension(const std::string &file_path);

    static const std::vector<std::string> allowed_mime_types;
    static const std::vector<std::string> allowed_extensions;
};

#endif
