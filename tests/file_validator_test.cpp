#include <gtest/gtest.h>
#include "../src/file_validator.hpp"

// TEST(FileValidatorTest, ValidateValidFile)
// {
//     EXPECT_TRUE(FileValidator::validate("test_files/valid.xlsx"));
// }

TEST(FileValidatorTest, ValidateInvalidFile)
{
    EXPECT_FALSE(FileValidator::validate("test_files/invalid.txt"));
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
