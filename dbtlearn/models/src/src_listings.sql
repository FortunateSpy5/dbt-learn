WITH listings AS (
    SELECT
        *
    FROM
        airbnb.raw.raw_listings
)
SELECT
    id AS listing_id,
    NAME AS listing_name,
    listing_url,
    room_type,
    minimum_nights,
    host_id,
    price AS price_str,
    created_at,
    updated_at
FROM
    listings
