select polo.polling_location
    , sum( peth.subeth_chinese ) as ch
        , sum( peth.subeth_indian ) as in
            , sum( peth.subeth_filipino ) as fi
                , sum( peth.subeth_japanese ) as ja
                    , sum( peth.subeth_vietnamese ) as vi
                        , sum( peth.subeth_korean ) as ko
                            , sum( peth.subeth_other_asian ) as oa
                                , sum( peth.subeth_hmong ) as hm
                                    , count( CASE WHEN peth.ethnicity_combined='A' THEN 1 END ) as aapi
                                        , count( peth.ethnicity_combined ) tot
                                        from phoenix_nv.person_ethnicity peth
                                        join phoenix_nv.person pers on (peth.person_id = pers.person_id)
                                        join vansync_nv.polling_locations polo on ( pers.van_precinct_id = polo.van_precinct_id )
                                        where pers.reg_on_current_file
                                        group by polo.polling_location;
