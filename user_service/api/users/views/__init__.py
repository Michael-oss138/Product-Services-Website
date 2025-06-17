from .list import view as list_view, url as list_url
from .create import view as create_view, url as create_url
from .by_id import urls as by_id_urls

__all__ = ["list_view", "create_view"]

urls = [list_url, create_url] + by_id_urls
