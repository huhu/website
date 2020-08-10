module.exports = {
    purge: [],
    theme: {
        fontFamily: {
            'open-sans': ['Open\\ Sans', 'sans-serif'],
            'roboto': ['Roboto', 'sans-serif'],
        },
        extend: {
            colors: {
                primary: 'var(--primary-color)',
                secondary: 'var(--secondary-color)',
            },
            animation: {
                'float-rotate': 'float-rotate 7s ease-in-out infinite',
            },
            keyframes: {
                'float-rotate': {
                    '0%': {
                        transform: 'rotate(-8deg) translateY(0)'
                    },
                    '50%': {
                        transform: 'rotate(4deg) translateY(-10px)'
                    },
                    '100%': {
                        transform: 'rotate(-8deg) translateY(0)'
                    }
                }
            }
        },
    },
    variants: {},
    plugins: [],
}
