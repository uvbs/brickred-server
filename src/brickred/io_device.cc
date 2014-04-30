#include <brickred/io_device.h>

#include <fcntl.h>
#include <unistd.h>
#include <cstddef>
#include <cstring>

#include <brickred/io_service.h>

namespace brickred {

IODevice::IODevice() : io_service_(NULL), fd_(-1)
{
}

IODevice::~IODevice()
{
    detachIOService();
}

bool IODevice::attachIOService(IOService *io_service)
{
    if (io_service_ != NULL) {
        detachIOService();
    }

    if (!io_service->addIODevice(this)) {
        return false;
    }
    io_service_ = io_service;

    return true;
}

void IODevice::detachIOService()
{
    if (NULL == io_service_) {
        return;
    }
    io_service_->removeIODevice(this);
    io_service_ = NULL;
}

void IODevice::setReadCallback(ReadCallback read_cb)
{
    read_cb_ = read_cb;
    if (io_service_ != NULL) {
        io_service_->updateIODevice(this);
    }
}

void IODevice::setWriteCallback(WriteCallback write_cb)
{
    write_cb_ = write_cb;
    if (io_service_ != NULL) {
        io_service_->updateIODevice(this);
    }
}

void IODevice::setErrorCallback(ErrorCallback error_cb)
{
    error_cb_ = error_cb;
}

int IODevice::read(char *buffer, size_t size)
{
    return ::read(fd_, buffer, size);
}

int IODevice::write(const char *buffer, size_t size)
{
    return ::write(fd_, buffer, size);
}

bool IODevice::setNonblock()
{
    int flags = ::fcntl(fd_, F_GETFL, 0);
    if (::fcntl(fd_, F_SETFL, flags | O_NONBLOCK) != 0) {
        return false;
    }

    return true;
}

bool IODevice::setCloseOnExec()
{
    int flags = ::fcntl(fd_, F_GETFD, 0);
    if (::fcntl(fd_, F_SETFD, flags | FD_CLOEXEC) != 0) {
        return false;
    }

    return true;
}

} // namespace brickred

