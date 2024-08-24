from ansible.plugins.callback import CallbackBase
from datetime import datetime, timedelta

class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'notification'
    CALLBACK_NAME = 'custom_callback'

    def __init__(self):
        super(CallbackModule, self).__init__()
        self.start_time = None  # Store start time for retries

    def v2_runner_retry(self, result):
        if self.start_time is None:
            self.start_time = datetime.now()  # Capture start time on first retry

        elapsed_time = datetime.now() - self.start_time
        retries_left = result._result.get('retries') - result._result.get('attempts')
        countdown = timedelta(seconds=retries_left * 10) - elapsed_time
        minutes, seconds = divmod(countdown.total_seconds(), 60)  # Change here

        message = f"WAIT FOR THE SERVER TO BE READY FOR THE NEXT TASK - Time Remaining: {minutes:.0f} minutes, {seconds:.0f} seconds"
        self._display.display(message, color='yellow')
