from .get import view as get_view, url as get_url
from .update import view as update_view, url as update_url
from .delete import view as delete_view, url as delete_url

__all__ = ["get_view", "update_view", "delete_view"]

urls = [get_url, update_url, delete_url]
