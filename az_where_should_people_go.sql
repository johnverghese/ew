with myv_info as (
    select p.van_precinct_id
                , p.van_precinct_name
                        , count(p.person_id) as voters
                                , count(CASE WHEN p.party_name_dnc='Democratic' THEN p.person_id END ) as dems
                                            , sum(a.dnc_2020_volprop_overall_rank) as vol_propensity_sum
                                                    , avg(a.dnc_2020_volprop_overall_rank) as vol_prop_mean
                                                            , median(a.dnc_2020_volprop_overall_rank) as vol_prop_median
                                                                from phoenix_az.all_scores_2020 a
                                                                    join phoenix_az.person p on ( p.person_id = a.person_id )
                                                                        where dnc_2020_volprop_overall_rank is not null and p.reg_on_current_file
                                                                            group by p.van_precinct_id, p.van_precinct_name
                                                                            )

                                                                            /*
                                                                            , tiers as (
                                                                                select prmc.van_precinct_id
                                                                                        , count( CASE WHEN tiers.tier='tier 1' THEN tiers.source_id END ) as t1
                                                                                                , count( CASE WHEN tiers.tier='tier 2' THEN tiers.source_id END ) as t2
                                                                                                        , count( CASE WHEN tiers.tier='tier 3' THEN tiers.source_id END ) as t3
                                                                                                                , count( CASE WHEN tiers.tier='tier 4' THEN tiers.source_id END ) as t4
                                                                                                                        , count( CASE WHEN tiers.tier='tier 5' THEN tiers.source_id END ) as t5
                                                                                                                            from jverghese.az_tiers tiers
                                                                                                                                join vansync_az.person_records_myc prmc on ( prmc.myc_van_id = tiers.source_id )
                                                                                                                                    group by prmc.van_precinct_id
                                                                                                                                    )*/

                                                                                                                                    , contacts_myc as (
                                                                                                                                        select van_precinct_id
                                                                                                                                                    , count(contacts_contact_id) as myc_attempts
                                                                                                                                                        from phoenix_demswarren20_vansync_derived.contacts_myc cmc
                                                                                                                                                            where state_code='AZ' and van_precinct_id is not null
                                                                                                                                                                group by van_precinct_id
                                                                                                                                                                )

                                                                                                                                                                ,   contacts_myv as (       
                                                                                                                                                                        select van_precinct_id
                                                                                                                                                                                    , count(contacts_contact_id) as myv_attempts
                                                                                                                                                                                        from phoenix_demswarren20_vansync_derived.contacts_myv cmv
                                                                                                                                                                                            where state_code='AZ' and van_precinct_id is not null
                                                                                                                                                                                                group by van_precinct_id
                                                                                                                                                                                                )

                                                                                                                                                                                                select prec.county
                                                                                                                                                                                                        , ebase.us_cong_district_latest
                                                                                                                                                                                                            ,   state_senate_district_latest
                                                                                                                                                                                                                , state_house_district_latest
                                                                                                                                                                                                                        , myv_info.*
                                                                                                                                                                                                                            , contacts_myv.myv_attempts
                                                                                                                                                                                                                                , contacts_myc.myc_attempts
                                                                                                                                                                                                                                /*      , tiers.t1
                                                                                                                                                                                                                                    , tiers.t2
                                                                                                                                                                                                                                        , tiers.t3
                                                                                                                                                                                                                                            , tiers.t4
                                                                                                                                                                                                                                                , tiers.t5
                                                                                                                                                                                                                                                */
                                                                                                                                                                                                                                                from phoenix_az.precinct prec
                                                                                                                                                                                                                                                join phoenix_az.ebase_precinct_districts ebase on ( ebase.dnc_precinct_id = prec.dnc_precinct_id )
                                                                                                                                                                                                                                                                                                                                                        and ebase.state_senate_district_latest is not null
                                                                                                                                                                                                                                                                                                                                                        --left join tiers on ( tiers.van_precinct_id = prec.van_precinct_id )
                                                                                                                                                                                                                                                                                                                                                        left join contacts_myc on (contacts_myc.van_precinct_id = prec.van_precinct_id)
                                                                                                                                                                                                                                                                                                                                                        left join contacts_myv on (contacts_myv.van_precinct_id = prec.van_precinct_id)
                                                                                                                                                                                                                                                                                                                                                        left join myv_info on (myv_info.van_precinct_id = prec.van_precinct_id )
                                                                                                                                                                                                                                                                                                                                                        where prec.is_active;
