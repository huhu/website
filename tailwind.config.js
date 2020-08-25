module.exports = {
    purge: {
        enabled: process.env.ENV === 'production',
        content: [
            './templates/**/*.html',
            './static/**/*.html',
        ],
    },
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
            width: {
                '72': '18rem',
                '84': '21rem',
                '96': '24rem',
                '104': '28rem',
                '112': '32rem',
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
