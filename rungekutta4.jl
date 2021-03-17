function rungekutta4(dy, y0, h)
    k1 = dy(y0)
    k2 = dy(y0 + k1 * h/2)
    k3 = dy(y0 + k2 * h/2)
    k4 = dy(y0 + k3 * h)
    y1 = y0 + (h/6) * (k1 + 2*k2 + 2*k3 + k4)

    return y1
end
