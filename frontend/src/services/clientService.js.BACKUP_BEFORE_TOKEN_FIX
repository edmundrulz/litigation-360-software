export async function fetchAllClients() {
  try {
    const res = await fetch('/api/clients');

    if (!res.ok) {
      throw new Error('Failed to fetch clients');
    }

    return await res.json();

  } catch (error) {
    console.error('CLIENT SERVICE ERROR:', error);
    return [];
  }
}

