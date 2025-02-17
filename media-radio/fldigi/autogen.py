#!/usr/bin/env python3

from bs4 import BeautifulSoup

async def generate(hub, **pkginfo):
	base_url = "https://www.w1hkj.org/files/fldigi/"
	html_data = await hub.pkgtools.fetch.get_page(f"{base_url}")
	soup = BeautifulSoup(html_data, "html.parser")
	links = soup.find_all("a")
	version = None

	for link in links:
		filename = link.get("href")
		if filename and filename.endswith(".tar.gz"):
			version = filename.rsplit("-", 1)[-1].rstrip(".tar.gz")

			try:
				list(map(int, version.split(".")))
				break

			except ValueError:
				continue

	if version:
		url = f"{base_url}{filename}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=filename)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
