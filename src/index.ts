import { Cloudflare } from "cloudflare"

function error(message: string) {
  return (error) => console.error(message, error)
}

const api = new Cloudflare({
    apiToken: process.env.CLOUDFLARE_API_TOKEN
})

const acc = (await api.accounts.list()).result.at(0)!

for await (const app of api.zeroTrust.access.applications.list({
  account_id: acc.id
})) {
  await api.zeroTrust.access.applications.delete(app.id, {
    account_id: acc.id
  }).catch(error("Error deleting application."))
}

for await (const policy of api.zeroTrust.access.policies.list({
  account_id: acc.id
})) {
  await api.zeroTrust.access.policies.delete(policy.id, {
    account_id: acc.id
  }).catch(error("Error deleting policy."))
}

for await (const list of api.zeroTrust.gateway.lists.list({
  account_id: acc.id
})) {
  await api.zeroTrust.gateway.lists.delete(list.id, {
    account_id: acc.id
  }).catch(error("Error deleting list"))
}