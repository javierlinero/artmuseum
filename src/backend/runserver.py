import sys
import argparse
import puam_flask_endpoints

def main():

    parser = argparse.ArgumentParser(
        description='The registrar application')
    parser.add_argument('port',
        type=int, help='the port at which the server is listening')
    args = parser.parse_args()

    port = int(args.port)

    try:
        puam_flask_endpoints.app.run(host='0.0.0.0', port=port, debug=True)
    except Exception as ex:
        print(ex, file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
