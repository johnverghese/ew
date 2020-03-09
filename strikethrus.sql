with sl as (
  select name
        , vanid
          from van.saved_lists
            where name SIMILAR TO '%(Staff|Vol)%'
            )

            , ev as (
              select ev.myv_van_id
                from analytics_nv.early_vote_myv ev 
                )


                --Independent American Party Members
                , iap as (
                  select p.myv_van_id
                    from phoenix_nv.person p
                      where p.party_id=6 and
                            p.reg_on_current_file
                            )


                            , strikethrus as (
                              select ev.myv_van_id
                                from ev
                                  union
                                    select iap.myv_van_id
                                      from iap
                                      )

                                      select distinct sl.name
                                            , sl.vanid
                                                , p.county_name
                                                        , p.van_precinct_name
                                                                , p.first_name
                                                                    , p.last_name
                                                                            , p.age_combined
                                                                                , p.gender_combined
                                                                                    , p.voting_street_address
                                                                                        , p.voting_street_address_2
                                                                                            , p.voting_city
                                                                                                , p.voting_zip
                                                                                                    , split_part(p.voting_street_address, ' ', 1) as house_number
                                                                                                        , split_part(p.voting_street_address, ' ', 2) as street_name
                                                                                                            , split_part(p.voting_street_address, ' ', 1) % 2 as odd_even
                                                                                                            from strikethrus st 
                                                                                                            join sl on ( sl.vanid = st.myv_van_id )
                                                                                                            join phoenix_nv.person p on ( sl.vanid = p.myv_van_id )
                                                                                                            where p.reg_on_current_file
                                                                                                            order by sl.name
                                                                                                                        , p.county_name
                                                                                                                              , street_name
                                                                                                                                    , odd_even
                                                                                                                                          , house_number
