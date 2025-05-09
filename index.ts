import { Cloudflare } from "cloudflare"

const api = new Cloudflare({
    apiKey: process.env.CLOUDFLARE_API_KEY,
    apiEmail: process.env.CLOUDFLARE_EMAIL,
})

const acc = (await api.accounts.list()).result.at(0)!

console.log("policies", await api.zeroTrust.access.policies.list({
    account_id: acc.id,
}))