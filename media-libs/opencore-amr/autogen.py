#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	name = pkginfo.get("name")
	html_data = await hub.pkgtools.fetch.get_page(f"https://sourceforge.net/projects/{name}/files/{name}")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None

	for link in links:
		href = link.get("href")
		if href and "download" in href:
			parts = href.split("/")
			final_name = parts[-2]
			version = final_name.rsplit("-", 1)[-1].rstrip(".tar.gz")

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		url = f"https://downloads.sourceforge.net/{name}/{name}/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
