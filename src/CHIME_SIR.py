# -*- coding: utf-8 -*-
"""
Created on Fri Apr  3 14:26:07 2020

@author: Anshul
"""

"""
# In the terminal, we need to set up a python environment first:
conda create --name env_sflCHARM python=3.6 pandas numpy altair
source activate env_sflCHARM
pip install streamlit
"""

from functools import reduce
from typing import Tuple, Dict, Any
import pandas as pd
# import streamlit as st
import numpy as np
import altair as alt

# Assumptions

S_default = 21300000
known_infections = 1000 # update daily
known_cases = 400 # update daily

current_hosp = known_cases
doubling_time = 6
relative_contact_rate = 0

hosp_rate = 0.05

icu_rate = 0.02

vent_rate = 0.01

hosp_los = 7
icu_los = 9
vent_los = 10

Penn_market_share = 0.15

S = S_default

initial_infections = known_infections

total_infections = current_hosp / Penn_market_share / hosp_rate
detection_prob = initial_infections / total_infections

S, I, R = S, initial_infections / detection_prob, 0

intrinsic_growth_rate = 2 ** (1 / doubling_time) - 1

recovery_days = 14.0
# mean recovery rate, gamma, (in 1/days).
gamma = 1 / recovery_days

# Contact rate, beta
beta = (
    intrinsic_growth_rate + gamma
) / S * (1-relative_contact_rate) # {rate based on doubling time} / {initial S}


r_t = beta / gamma * S # r_t is r_0 after distancing

print(r_t)

r_naught = r_t / (1-relative_contact_rate)

doubling_time_t = 1/np.log2(beta*S - gamma +1) # doubling time after distancing

print(doubling_time_t)

# The SIR model, one time step
def sir(y, beta, gamma, N):
    S, I, R = y
    Sn = (-beta * S * I) + S
    In = (beta * S * I - gamma * I) + I
    Rn = gamma * I + R
    if Sn < 0:
        Sn = 0
    if In < 0:
        In = 0
    if Rn < 0:
        Rn = 0
    
    scale = N / (Sn + In + Rn)
    return Sn * scale, In * scale, Rn * scale

# Run the SIR model forward in time
def sim_sir(S, I, R, beta, gamma, n_days, beta_decay=None):
    N = S + I + R
    s, i, r = [S], [I], [R]
    for day in range(n_days):
        y = S, I, R
        S, I, R = sir(y, beta, gamma, N)
        if beta_decay:
            beta = beta * (1 - beta_decay)
        s.append(S)
        i.append(I)
        r.append(R)
    
    s, i, r = np.array(s), np.array(i), np.array(r)
    return s, i, r

# n_days = 30, 200, 60, 1

n_days = 30

beta_decay = 0.0
s, i, r = sim_sir(S, I, R, beta, gamma, n_days, beta_decay=beta_decay)

hosp = i * hosp_rate * Penn_market_share
icu = i * icu_rate * Penn_market_share
vent = i * vent_rate * Penn_market_share

days = np.array(range(0, n_days + 1))
data_list = [days, hosp, icu, vent]
data_dict = dict(zip(["day", "hosp", "icu", "vent"], data_list))

projection = pd.DataFrame.from_dict(data_dict)

# New cases
projection_admits = projection.iloc[:-1, :] - projection.shift(1)
projection_admits[projection_admits < 0] = 0

plot_projection_days = n_days - 10
projection_admits["day"] = range(projection_admits.shape[0])

def new_admissions_chart(projection_admits: pd.DataFrame, plot_projection_days: int) -> alt.Chart:
    """docstring"""
    projection_admits = projection_admits.rename(columns={"hosp": "Hospitalized", "icu": "ICU", "vent": "Ventilated"})
    return (
        alt
        .Chart(projection_admits.head(plot_projection_days))
        .transform_fold(fold=["Hospitalized", "ICU", "Ventilated"])
        .mark_line(point=True)
        .encode(
            x=alt.X("day", title="Days from today"),
            y=alt.Y("value:Q", title="Daily admissions"),
            color="key:N",
            tooltip=["day", "key:N"]
        )
        .interactive()
    )

# st.altair_chart(new_admissions_chart(projection_admits, plot_projection_days), use_container_width=True)

new_admissions_chart(projection_admits, plot_projection_days)

admits_table = projection_admits[np.mod(projection_admits.index, 7) == 0].copy()
admits_table["day"] = admits_table.index
admits_table.index = range(admits_table.shape[0])
admits_table = admits_table.fillna(0).astype(int)

# st.dataframe(admits_table)

print(admits_table)


