#include <assert.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

__attribute__((nonnull))
int copy_file(const char* restrict src, const char* restrict dst) {
    struct stat src_stat;
    if (stat(src, &src_stat) < 0) {
        printf("Source: %s\nDest: %s\n", src, dst);
        perror("stat");
        return -1;
    }

    char* buf = malloc(src_stat.st_size);
    if (buf == NULL) {
        perror("malloc");
        return -1;
    }
    
    int src_fd = open(src, O_RDONLY);
    if (src_fd < 0) {
        perror("open (src)");
        free(buf);
        return -1;
    }
    int dst_fd = open(dst, O_WRONLY | O_CREAT, src_stat.st_mode);
    if (dst_fd < 0) {
        perror("open (dst)");
        close(src_fd);
        free((void*) buf);
        return -1;
    }

    if (read(src_fd, buf, src_stat.st_size) != src_stat.st_size) {
        perror("read (error or incomplete)");
        close(src_fd);
        close(dst_fd);
        free(buf);
        return -1;
    }

    if (write(dst_fd, buf, src_stat.st_size) != src_stat.st_size) {
        perror("write (error or incomplete)");
        close(src_fd);
        close(dst_fd);
        free(buf);
        return -1;
    }

    close(src_fd);
    close(dst_fd);
    free(buf);
    return dst_fd;
}

__attribute__((nonnull))
const char* ask_path(const char* restrict question) {
    assert(write(STDOUT_FILENO, question, strnlen(question, 16)) > 0);

    char* buf = (char*) malloc(PATH_MAX * sizeof(char));
    assert(buf);
    ssize_t result = read(STDIN_FILENO, buf, PATH_MAX);
    if (result <= 0) {
        fputs("Reading path from stdin failed\n", stderr);
        free(buf);
        exit(-1);
    }

    void* realloc_res = realloc(buf, result);
    if (realloc_res == NULL) {
        free(buf);
        fputs("Shrinking buffer to size of read bytes failed\n", stderr);
        exit(-1);
    }
    buf = realloc_res;

    // Remove newline from fgets
    char* newline = strchr(buf, '\n');
    if (newline) {
        *newline = '\0';
    }

    return buf;
}

int main(int argc, const char* argv[]) {
    int success = EXIT_FAILURE;
    const char* ask_source = "Source: ";
    const char* ask_dest = "Destination: ";

    if (argc == 3) {
        printf("Source is %s\nDest is %s\n", argv[1], argv[2]);
        success = copy_file(argv[1], argv[2]);
    } else if (argc == 2) {
        printf("Source is %s\n", argv[1]);
        const char* dst = ask_path(ask_dest);

        success = copy_file(argv[1], dst);
        free((void*) dst);

        if (success > 0) {
            close(success);
            puts("File copied successfully");
            success = EXIT_SUCCESS;
        }
    } else if (argc == 1) {
        const char* src = ask_path(ask_source);
        assert(src != NULL);
        const char* dst = ask_path(ask_dest);;
        assert(dst != NULL);

        success = copy_file(src, dst);

        free((void*) src);
        free((void*) dst);

        if (success > 0) {
            close(success);
            puts("File copied successfully");
            success = EXIT_SUCCESS;
        }
    } else {
        assert(argc > 0);
        printf("%s source dest\n", argv[0]);
    }

    return success;
}
