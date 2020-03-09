
p table if exists analytics_az.gotv_ptg;
create table analytics_az.gotv_ptg as (


with az_canvassers as (
  select ea.myc_van_id, ea.event_date, ea.shift_id, ar.fo_name, ea.mrr_status_name, ea.event_type_name, surv.survey_response_name
    from phoenix_demswarren20_vansync_derived.event_attendees ea
      join vansync_az.activity_regions ar on (ea.myc_van_id = ar.myc_van_id)
        join vansync_az.contacts_survey_responses_myc sr on ( ea.myc_van_id = sr.myc_van_id ) and ( sr.survey_question_id = 373929 )
          join vansync_az.survey_responses surv using ( survey_response_id)
            where ea.state_code='AZ' and ( ea.event_type_name='Canvass' or (ea.event_type_name='National GOTV' and ea.volunteer_activity_name='Canvasser') )
            )

            , az_phonebankers as (
              select ea.myc_van_id, ea.event_date, ea.shift_id, ar.fo_name, ea.mrr_status_name, ea.event_type_name, surv.survey_response_name
                from phoenix_demswarren20_vansync_derived.event_attendees ea
                  join vansync_az.activity_regions ar on (ea.myc_van_id = ar.myc_van_id)
                    join vansync_az.contacts_survey_responses_myc sr on ( ea.myc_van_id = sr.myc_van_id ) and ( sr.survey_question_id = 373929 )
                      join vansync_az.survey_responses surv using ( survey_response_id)
                        where ea.state_code='AZ' and ( ea.event_type_name='Phonebank' or (ea.event_type_name='National GOTV' and ea.volunteer_activity_name='Phonebanker') )
                        )

                        , canvass_counts as (
                          select fo_name
                                , mrr_status_name
                                        , event_date
                                            , event_type_name
                                                , 'Canvass' as type
                                                    , count(shift_id)
                                                        , survey_response_name
                                                          from az_canvassers
                                                            group by fo_name
                                                                , mrr_status_name
                                                                    , event_date
                                                                        , event_type_name
                                                                            , survey_response_name
                                                                            )

                                                                            , phonebank_counts as (
                                                                              select fo_name
                                                                                    , mrr_status_name
                                                                                          , event_date
                                                                                                , event_type_name
                                                                                                    , 'Phonebank' as type
                                                                                                        , count(shift_id)
                                                                                                            , survey_response_name
                                                                                                              from az_phonebankers
                                                                                                                group by fo_name
                                                                                                                    , mrr_status_name
                                                                                                                        , event_date
                                                                                                                            , event_type_name
                                                                                                                                , survey_response_name
                                                                                                                                )

                                                                                                                                , canv_phone as (
                                                                                                                                    select * from canvass_counts
                                                                                                                                        union
                                                                                                                                            select * from phonebank_counts
                                                                                                                                            )

                                                                                                                                            select date_trunc('week', canv_phone.event_date)::DATE as week
                                                                                                                                                , date_part('dow', canv_phone.event_date) as day
                                                                                                                                                  , canv_phone.*
                                                                                                                                                  from canv_phone
                                                                                                                                                  order by week, day, fo_name, event_type_name, mrr_status_name 
                                                                                                                                                    
                                                                                                                                                    );

