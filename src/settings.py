#!/usr/bin/env python

"""
NAME: COVID-19 CHIME MODELS
AUTHORS: jlubken, quinn-dougherty, cjbayesian, ecsmyth
SOURCE: https://github.com/CodeForPhilly/chime/blob/develop/src/penn_chime/settings.py
DATE ACCESSED: 2020-04-03
"""

from datetime import date

from .parameters import Parameters, Regions, Disposition


def get_defaults():
    return Parameters(
        population=3600000,
        current_hospitalized=69,
        date_first_hospitalized=date(2020,3,7),
        doubling_time=4.0,
        hospitalized=Disposition(0.025, 7),
        icu=Disposition(0.0075, 9),
        infectious_days=14,
        market_share=0.15,
        n_days=100,
        mitigation_date=date.today(),
        relative_contact_rate=0.3,
        ventilated=Disposition(0.005, 10),
    )
