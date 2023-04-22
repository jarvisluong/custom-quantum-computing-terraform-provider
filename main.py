import multiprocessing
import benchmark_runner
import task_loop

if __name__ == "__main__":
    param_queue = multiprocessing.Queue()
    long_operation_process = multiprocessing.Process(target=task_loop.main, args=(param_queue,))
    benchmark_get_best_device_process = multiprocessing.Process(target=benchmark_runner.main, args=(param_queue,))

    long_operation_process.start()
    benchmark_get_best_device_process.start()

    long_operation_process.join()
    benchmark_get_best_device_process.join()