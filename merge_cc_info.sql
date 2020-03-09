select fo_name::varchar
        , a.internal_precinct_id
                , a.county::varchar
                    , cc_fpr.van_precinct_name::varchar
                        , myc_van_id::varchar
                            , myv_van_id::varchar
                                , a.caucus_location as polling_location
                                    , first_name::varchar
                                        , last_name::varchar
                                            , email::varchar
                                                , phone::varchar
                                                        , 'Caucus Captain' as type
                                                            , CASE WHEN no_smartphone is not null or no_cellphone is not null THEN 'No' END as textable
                                                                , null as needs_review
                                                                from jverghese.cc_fpr
                                                                left join analytics_nv.delegate_apportionment a on (UPPER(a.county) = UPPER(cc_fpr.county)) and (a.precinct = cc_fpr.van_precinct_name)
                                                                where declined is null

                                                                union

                                                                select fo_name::varchar
                                                                        , a.internal_precinct_id
                                                                                , a.county::varchar
                                                                                    , c.van_precinct_name::varchar
                                                                                        , myc_van_id::varchar
                                                                                            , myv_van_id::varchar
                                                                                                , a.caucus_location as polling_location
                                                                                                    , first_name::varchar
                                                                                                        , last_name::varchar
                                                                                                            , email::varchar
                                                                                                                , phone::varchar
                                                                                                                    , 'Caucus Captain' as type
                                                                                                                        , null as textable
                                                                                                                            , 'Yes' as needs_review
                                                                                                                            from analytics_nv.caucus_captain_final_progress c
                                                                                                                            left join analytics_nv.delegate_apportionment a on (UPPER(a.county) = UPPER(c.county)) and (a.precinct = c.van_precinct_name)
                                                                                                                            where ( myv_van_id not in ( select myv_van_id from jverghese.cc_fpr ) or myv_van_id is null )
                                                                                                                                and ( myc_van_id not in (select myc_van_id from jverghese.cc_fpr ) or myc_van_id is null )
                                                                                                                                  
                                                                                                                                  order by fo_name, last_name;
