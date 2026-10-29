-- =====================================================================
-- dim_track.sql
-- Location: music_sales/models/chinook/ in the ist722dbt repository
-- Design:  dim_track(2) sheet, 1. Bus_MatrixV7_simplified.xlsx
--          (same columns and joins as the dim_track sheet's query)
-- Grain:   one row per track (3,503 rows)
-- =====================================================================

{{ config(materialized='table') }}

with stg_track as (
    select * from {{ source('chinook', 'track') }}
),

stg_album as (
    select * from {{ source('chinook', 'album') }}
),

stg_artist as (
    select * from {{ source('chinook', 'artist') }}
),

stg_genre as (
    select * from {{ source('chinook', 'genre') }}
),

stg_mediatype as (
    select * from {{ source('chinook', 'mediatype') }}
)

select
    t.trackid        as trackkey,
    t.trackid        as trackid,
    t.name           as trackname,
    al.title         as album,
    a.name           as artist,
    m.name           as mediatype,
    g.name           as genre,
    t.composer       as composer,
    t.milliseconds   as lengthms,
    t.bytes          as sizebytes,
    t.unitprice      as unitprice

from stg_track as t

left join stg_mediatype as m
    on t.mediatypeid = m.mediatypeid

left join stg_genre as g
    on t.genreid = g.genreid

left join stg_album as al
    on al.albumid = t.albumid

left join stg_artist as a
    on a.artistid = al.artistid
